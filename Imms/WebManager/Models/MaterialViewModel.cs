using System;
using System.Collections.Generic;
using System.Linq;
using Imms.Mes.Data.Domain;
using Microsoft.EntityFrameworkCore;

namespace Imms.WebManager.Models
{
    public class BomTree
    {
        public long BomId { get; set; }
        public long ComponentId { get; set; }
        public string ComponentCode { get; set; }
        public string ComponentName { get; set; }
        public int MaterialQty { get; set; }
        public int ComponentQty { get; set; }

        public List<BomTree> Children { get; set; }

        public bool Expanded { get; set; }
        public bool Leaf { get; set; }
        public bool Checked { get; set; }
    }

    public class BomTreeBuilder
    {
        public void ClearLeaf(List<BomTree> treeList)
        {
            for (int i = 0; i < treeList.Count; i++)
            {
                BomTree tree = treeList[i];
                if (tree.Leaf)
                {
                    treeList.Remove(tree);
                    i--;
                    continue;
                }

                this.ClearLeaf(tree.Children);
            }
        }

        public BomTree BuildBomTree(string materialCode, bool clearLeaf)
        {
            DbContext dbContext = GlobalConstants.DbContextFactory.GetContext();
            IQueryable<Bom> bomList = dbContext.Set<Bom>().Where(x => x.MaterialCode == materialCode);

            bool isFirst = true;
            BomTree self = new BomTree();
            self.Children = new List<BomTree>();

            foreach (Bom bom in bomList)
            {
                if (isFirst)
                {
                    self.BomId = -1;
                    self.MaterialQty = 1;
                    self.ComponentQty = 1;
                    self.ComponentId = bom.MaterialId;
                    self.ComponentCode = bom.MaterialCode;
                    self.ComponentName = bom.MaterialName;
                    self.Leaf = false;
                    self.Expanded = true;

                    isFirst = false;
                }
                BomTree treeBom = new BomTree();
                AssginBom(bom, treeBom);
                self.Children.Add(treeBom);

                this.FillTreeBom(treeBom, dbContext);
            }

            if (clearLeaf)
            {
                this.ClearLeaf(self.Children);
            }
            if (self.Children.Count == 0)
            {
                return null;
            }
            return self;
        }

        private static void AssginBom(Bom bom, BomTree treeBom)
        {
            treeBom.BomId = bom.RecordId;
            treeBom.ComponentId = bom.ComponentId;
            treeBom.ComponentCode = bom.ComponentCode;
            treeBom.ComponentName = bom.ComponentName;
            treeBom.MaterialQty = bom.MaterialQty;
            treeBom.ComponentQty = bom.ComponentQty;
            if (treeBom.ComponentQty == 0)
            {
                treeBom.ComponentQty = 1;
            }
        }

        private void FillTreeBom(BomTree parent, DbContext dbContext)
        {
            string materialCode = parent.ComponentCode;
            List<Bom> children = dbContext.Set<Bom>().Where(x => x.MaterialCode == materialCode).ToList();
            int childrentCount = children.Count;
            parent.Expanded = childrentCount > 0;
            parent.Leaf = childrentCount == 0;
            parent.Children = new List<BomTree>();
            foreach (Bom childBom in children)
            {
                BomTree childTree = new BomTree();
                AssginBom(childBom, childTree);
                parent.Children.Add(childTree);
                this.FillTreeBom(childTree, dbContext);
            }
        }
    }
}
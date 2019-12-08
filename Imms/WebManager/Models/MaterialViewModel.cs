using System;
using System.Collections.Generic;
using System.Linq;
using Imms.Mes.Data.Domain;
using Microsoft.EntityFrameworkCore;

namespace Imms.WebManager.Models
{
    public class BomTree : Bom
    {
        public bool Expanded { get; set; }
        public bool Leaf { get; set; }
        public List<BomTree> Children { get; set; }
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

                ClearLeaf(tree.Children);
            }
        }

        public List<BomTree> BuildBomTree(string materialCode, bool clearLeaf)
        {
            DbContext dbContext = GlobalConstants.DbContextFactory.GetContext();
            IQueryable<Bom> bomList = dbContext.Set<Bom>().Where(x => x.MaterialCode == materialCode);
            List<BomTree> result = new List<BomTree>();
            foreach (Bom bom in bomList)
            {
                BomTree treeBom = new BomTree();
                treeBom.Clone(bom);
                result.Add(treeBom);

                this.FillTreeBom(treeBom, dbContext);
            }

            if (clearLeaf)
            {
                this.ClearLeaf(result);
            }

            return result;
        }

        private void FillTreeBom(BomTree treeBom, DbContext dbContext)
        {
            string materialCode = treeBom.ComponentCode;
            List<Bom> children = dbContext.Set<Bom>().Where(x => x.MaterialCode == materialCode).ToList();
            int childrentCount = children.Count;
            treeBom.Expanded = childrentCount > 0;
            treeBom.Leaf = childrentCount == 0;

            treeBom.Children = new List<BomTree>();
            foreach (Bom childBom in children)
            {
                BomTree child = new BomTree();
                child.Clone(childBom);
                treeBom.Children.Add(child);

                this.FillTreeBom(child, dbContext);
            }
        }
    }
}
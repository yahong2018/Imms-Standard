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
        public List<BomTree> BuildBomTree(string materialCode, int level)
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

            return result;
        }

        private void FillTreeBom(BomTree treeBom, DbContext dbContext)
        {
            string materialCode = treeBom.ComponentCode;
            List<Bom> children = dbContext.Set<Bom>().Where(x => x.MaterialCode == materialCode).ToList();
            int childrentCount = children.Count;
            if (childrentCount > 0)
            {
                treeBom.Leaf = false;
                treeBom.Expanded = true;
            }
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
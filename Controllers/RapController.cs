using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using QuanLyRapChieuPhim.Data;
using QuanLyRapChieuPhim.Models;

namespace QuanLyRapChieuPhim.Controllers
{
    public class RapController : Controller
    {
        private QuanLyRapChieuPhimContext db = new QuanLyRapChieuPhimContext();

        // GET: Rap
        public ActionResult Index()
        {
            return View(db.RAPs.ToList());
        }

        // GET: Rap/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RAP rAP = db.RAPs.Find(id);
            if (rAP == null)
            {
                return HttpNotFound();
            }
            return View(rAP);
        }

        // GET: Rap/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Rap/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ID,MARAP,TENRAP,DIACHI")] RAP rAP)
        {
            if (ModelState.IsValid)
            {
                db.RAPs.Add(rAP);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(rAP);
        }

        // GET: Rap/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RAP rAP = db.RAPs.Find(id);
            if (rAP == null)
            {
                return HttpNotFound();
            }
            return View(rAP);
        }

        // POST: Rap/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,MARAP,TENRAP,DIACHI")] RAP rAP)
        {
            if (ModelState.IsValid)
            {
                db.Entry(rAP).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(rAP);
        }

        // GET: Rap/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            RAP rAP = db.RAPs.Find(id);
            if (rAP == null)
            {
                return HttpNotFound();
            }
            return View(rAP);
        }

        // POST: Rap/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            RAP rAP = db.RAPs.Find(id);
            db.RAPs.Remove(rAP);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}

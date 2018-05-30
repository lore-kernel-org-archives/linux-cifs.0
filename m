From: Long Li <longli@microsoft.com>
Subject: RE: [Patch v2 02/15] CIFS: Add support for direct pages in rdata
Date: Wed, 30 May 2018 20:57:59 +0000
Message-ID: <SN4PR2101MB07338FEF563C5EE974191591CE6C0@SN4PR2101MB0733.namprd21.prod.outlook.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
 <20180530194807.31657-3-longli@linuxonhyperv.com>
 <14063C7AD467DE4B82DEDB5C278E8663B38F01CD@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14063C7AD467DE4B82DEDB5C278E8663B38F01CD@FMSMSX108.amr.corp.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> Subject: RE: [Patch v2 02/15] CIFS: Add support for direct pages in rdata
>=20
> >-----Original Message-----
> >From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> >owner@vger.kernel.org] On Behalf Of Long Li
> >Sent: Wednesday, May 30, 2018 3:48 PM
> >To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org;
> >samba- technical@lists.samba.org; linux-kernel@vger.kernel.org; linux-
> >rdma@vger.kernel.org
> >Cc: Long Li <longli@microsoft.com>
> >Subject: [Patch v2 02/15] CIFS: Add support for direct pages in rdata
> >
> >From: Long Li <longli@microsoft.com>
> >
> >Add a function to allocate rdata without allocating pages for data
> >transfer. This gives the caller an option to pass a number of pages
> >that point to the data buffer.
> >
> >rdata is still reponsible for free those pages after it's done.
> >
> >Signed-off-by: Long Li <longli@microsoft.com>
> >---
> > fs/cifs/cifsglob.h |  2 +-
> > fs/cifs/file.c     | 23 ++++++++++++++++++++---
> > 2 files changed, 21 insertions(+), 4 deletions(-)
> >
> >diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h index
> >8d16c3e..56864a87 100644
> >--- a/fs/cifs/cifsglob.h
> >+++ b/fs/cifs/cifsglob.h
> >@@ -1179,7 +1179,7 @@ struct cifs_readdata {
> > 	unsigned int			tailsz;
> > 	unsigned int			credits;
> > 	unsigned int			nr_pages;
> >-	struct page			*pages[];
> >+	struct page			**pages;
> > };
> >
> > struct cifs_writedata;
> >diff --git a/fs/cifs/file.c b/fs/cifs/file.c index 23fd430..1c98293
> >100644
> >--- a/fs/cifs/file.c
> >+++ b/fs/cifs/file.c
> >@@ -2880,13 +2880,13 @@ cifs_strict_writev(struct kiocb *iocb, struct
> >iov_iter *from)  }
> >
> > static struct cifs_readdata *
> >-cifs_readdata_alloc(unsigned int nr_pages, work_func_t complete)
> >+cifs_readdata_direct_alloc(struct page **pages, work_func_t complete)
> > {
> > 	struct cifs_readdata *rdata;
> >
> >-	rdata =3D kzalloc(sizeof(*rdata) + (sizeof(struct page *) * nr_pages),
> >-			GFP_KERNEL);
> >+	rdata =3D kzalloc(sizeof(*rdata), GFP_KERNEL);
> > 	if (rdata !=3D NULL) {
> >+		rdata->pages =3D pages;
> > 		kref_init(&rdata->refcount);
> > 		INIT_LIST_HEAD(&rdata->list);
> > 		init_completion(&rdata->done);
> >@@ -2896,6 +2896,22 @@ cifs_readdata_alloc(unsigned int nr_pages,
> >work_func_t complete)
> > 	return rdata;
> > }
> >
> >+static struct cifs_readdata *
> >+cifs_readdata_alloc(unsigned int nr_pages, work_func_t complete) {
> >+	struct page **pages =3D
> >+		kzalloc(sizeof(struct page *) * nr_pages, GFP_KERNEL);
> >+	struct cifs_readdata *ret =3D NULL;
> >+
> >+	if (pages) {
> >+		ret =3D cifs_readdata_direct_alloc(pages, complete);
> >+		if (!ret)
> >+			kfree(pages);
> >+	}
> >+
> >+	return ret;
> >+}
> >+
> > void
> > cifs_readdata_release(struct kref *refcount)  { @@ -2910,6 +2926,7 @@
> >cifs_readdata_release(struct kref *refcount)
> > 	if (rdata->cfile)
> > 		cifsFileInfo_put(rdata->cfile);
> >
> >+	kvfree(rdata->pages);
>=20
> Is the kvfree() correct?
>=20
> You use kzalloc() and kfree in cifs_readdata_alloc().

This function is shared by both non-direct I/O and direct I/O code paths.

Direct I/O uses kvmalloc to allocate pages, so kvfree is used here to handl=
e both cases.

>=20
> Mike
>=20
> > 	kfree(rdata);
> > }
> >
> >--
> >2.7.4
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> >in the body of a message to majordomo@vger.kernel.org More majordomo
> >info at
> >https://na01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fvger.k
> e
> >rnel.org%2Fmajordomo-
> info.html&data=3D02%7C01%7Clongli%40microsoft.com%7C
> >e810388a534643737ab108d5c66bd6df%7C72f988bf86f141af91ab2d7cd011db
> 47%7C1
> >%7C0%7C636633088833938755&sdata=3DiHKiji2rUhLHpbH5x13SJBWCvHExSr4a
> rz9Xiv3
> >1rMQ%3D&reserved=3D0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in =
the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> https://na01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fvger.ke
> rnel.org%2Fmajordomo-
> info.html&data=3D02%7C01%7Clongli%40microsoft.com%7Ce810388a53464373
> 7ab108d5c66bd6df%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63
> 6633088833938755&sdata=3DiHKiji2rUhLHpbH5x13SJBWCvHExSr4arz9Xiv31rMQ
> %3D&reserved=3D0

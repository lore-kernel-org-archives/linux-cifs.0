From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: When "refer file directly", make new inode cache
 if "uniqueid is different"
Date: Mon, 13 Apr 2015 16:42:35 -0400
Message-ID: <20150413164235.2f4bd67b@synchrony.poochiereds.net>
References: <549A249A.3080000@nttcom.co.jp>
	<20150407064551.36374c43@tlielax.poochiereds.net>
	<CAH2r5ms5wn1ii563gK=+=koeQEmy5gY=xTP+Y8_GGjyPJwznzQ@mail.gmail.com>
	<5526335C.3030701@nttcom.co.jp>
	<20150410091647.39fb6515@synchrony.poochiereds.net>
	<CADT32eK6Zb7arYFyCPc+yt509P3pgg65bModxgNLyN1vb-a2-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eK6Zb7arYFyCPc+yt509P3pgg65bModxgNLyN1vb-a2-w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 12 Apr 2015 23:24:59 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I am not sure if ESTALE or ENOENT would have an effect on a dcache entry.
> A dcache entry and dentry are two different things, as I understand.

Oh, in this case I was specifically referring to the kernel's cache of
dentries as the dcache.

> In this case, dcache entry has not changed, what has changed is the dentry,
> specifically the inode it points to, so there is really no reason to purge
> and reinstate a dcache entry.
> 

No, the dentry has changed. We did an operation against the server and
found that the underlying inode type is different.

In practical terms, the Linux dcache should handle that by dropping the
old dentry and instantiating a new one. So, I think that returning
ESTALE is a better error there since it should trigger the upper VFS
layers to do just that.

> On Fri, Apr 10, 2015 at 8:16 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > On Thu, 9 Apr 2015 17:07:56 +0900
> > Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org> wrote:
> >
> >> On 2015/04/07 23:39, Steve French wrote:
> >> > On Tue, Apr 7, 2015 at 5:45 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >> >> On Wed, 24 Dec 2014 11:27:38 +0900
> >> >> Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org> wrote:
> >> >>
> >> >>> When refer file "directly" (e.g. ls -li <filename>),
> >> >>>  if file is same name, old inode cache is used.
> >> >>> This causes that client shows wrong(old) inode number.
> >> >>> So this patch is that if uniqueid is different, return error.
> >> >>>
> >> >>> ## But this patch is applicable to when Server is UNIX.
> >> >>> ## When Server is Windows, we need another new patch.
> >> >>>
> >> >>>
> >> >>> Reproducible sample :
> >> >>> 1. create file 'a' at cifs client.
> >> >>> 2. rm 'a' and touch 'b a' at server.
> >> >>> 3. ls -li 'a' at client, then client shows wrong(old) inode number.
> >> >>>
> >> >>> Bug link:
> >> >>> https://bugzilla.kernel.org/show_bug.cgi?id=90021
> >> >>>
> >> >>>
> >> >>>
> >> >>> Signed-off-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
> >> >>> diff -uprN -X linux-3.18-vanilla/Documentation/dontdiff linux-3.18-vanilla/fs/cifs/inode.c linux-3.18/fs/cifs/inode.c
> >> >>> --- linux-3.18-vanilla/fs/cifs/inode.c        2014-12-08 07:21:05.000000000 +0900
> >> >>> +++ linux-3.18/fs/cifs/inode.c        2014-12-19 11:07:59.127000000 +0900
> >> >>> @@ -402,9 +402,18 @@ int cifs_get_inode_info_unix(struct inod
> >> >>>                       rc = -ENOMEM;
> >> >>>       } else {
> >> >>>               /* we already have inode, update it */
> >> >>> +
> >> >>> +             /* if uniqueid is different, return error */
> >> >>> +             if (unlikely(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM &&
> >> >>> +                 CIFS_I(*pinode)->uniqueid != fattr.cf_uniqueid)) {
> >> >>> +                     rc = -ENOENT;
> >> >>> +                     goto cgiiu_exit;
> >> >>> +             }
> >> >>> +
> >> >>>               cifs_fattr_to_inode(*pinode, &fattr);
> >> >>>       }
> >> >>>
> >> >>> +cgiiu_exit:
> >> >>>       return rc;
> >> >>>  }
> >> >>>
> >> >>
> >> >> Returning ENOENT here seems like the wrong error to me. That path does
> >> >> exist, it just no longer refers to the same file as before.
> >> >>
> >> >> Maybe ESTALE would be better as it would allow the VFS layer
> >> >> to revalidate the dcache and invalidate the old dentry?
> >> >>
> >> >> --
> >> >> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >> >
> >> > Similar to what Jeff mentioned, isn't the nfs_relavidate_inode path
> >> > roughly equivalent to what we want here (where nfs.ko returns ESTALE
> >> > on various cases where we detect an inode that doesn't match what we
> >> > expect)?
> >>
> >> If uniqueid is different, return -ESTALE.
> >> If filetype is different, return -ENOENT.
> >> That's right?
> >>
> >> +             /* if filetype is different, return error */
> >> +             if (unlikely(((*pinode)->i_mode & S_IFMT) !=
> >> +                 (fattr.cf_mode & S_IFMT))) {
> >> +                     rc = -ENOENT;
> >> +                     goto cgiiu_exit;
> >> +             }
> >>
> >
> > No, I don't think so. In both cases, the dcache is wrong and the dentry
> > should be dropped and reinstantiated to point to a new inode. An ESTALE
> > return is the trigger for that to occur. An ENOENT return is going to
> > mean a stat() failure in your testcase, I think.
> >
> > So I think you want to return ESTALE in both cases. That said, please
> > do test it and ensure that it does the right thing.
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

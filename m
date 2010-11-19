From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/6] CIFS: Make cifsFileInfo_put work with strict cache mode
Date: Fri, 19 Nov 2010 11:03:45 +0300
Message-ID: <AANLkTi=e=ExtiYwkWm0tNFVFJWT9nv7HZZB_7PphFKLS@mail.gmail.com>
References: <1289459222-8210-1-git-send-email-piastryyy@gmail.com>
	<20101115073430.2254b19c@tlielax.poochiereds.net>
	<AANLkTi=SDMQfw4+rZSA_nvW-bq8hsH4ycVa6MXU+vSz=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=SDMQfw4+rZSA_nvW-bq8hsH4ycVa6MXU+vSz=@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/19 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> 2010/11/15 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>>
>> Not directly related to your patch, but what exactly is the purpose of
>> the "open_inode_helper"? It looks like "pile o' random junk that we do
>
> I agree that we can replace it with simply calling get_query_info from
> cifs_open.
>
>> for non-posix opens". Maybe it would be best to eliminate that function
>> altogether and further unify the posix and non-posix open code. Steve,
>> care to comment?
>>
>> Now that I'm done ranting, I don't think the invalidate mapping call
>> here is unnecessary. We will likely have already invalidated the cache
>> during the d_revalidate phase, and you're going to do it again below in
>> cifs_new_fileinfo.
>>
>
> I investigated it - you was right about unnecessary calling
> cifs_invalidate_mapping from open_inode_helper and cifs_new_fileinfo.
> But I found the following problem:
>
> When we execute script close2_problem.py (see in attachment) several
> times (e.x. for i in `seq 1 20`; do ./close2_problem.py; done) with
> (!) cifsFYI switched off it shows 'a' instead of 'x' (about 1-2 times
> for 20 runs). If we switch cifsFYI on it is almost always 'x' (true) -
> I have caught 'a' in this case one or two times for many-many runs.
> What do you think about it?

I continued the investigation and discovered that if we use
invalidate_inode_pages2 instead of invalidate_remote_inode - the
problem disappears! So, this is the patch we should apply to solve it
(I don't post it as a separate patch? because I think it needs more
discussing):

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 53cce8c..f20f200 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1591,7 +1591,10 @@ cifs_invalidate_mapping(struct inode *inode)
                if (rc)
                        cifs_i->write_behind_rc = rc;
        }
-       invalidate_remote_inode(inode);
+
+       if (inode->i_mapping)
+               invalidate_inode_pages2(inode->i_mapping);
+
        cifs_fscache_reset_inode_cookie(inode);
 }

-- 
Best regards,
Pavel Shilovsky.

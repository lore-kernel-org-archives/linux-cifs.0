From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: use sensible file nlink values if unprovided
Date: Fri, 5 Jul 2013 17:12:09 -0500
Message-ID: <CAH2r5msgztCnAZyvgmU3Y5Yupv-S=m1FXVzfN-RBQJbp0dRcyw@mail.gmail.com>
References: <1372961186-19213-1-git-send-email-ddiss@suse.de>
	<CAH2r5mtyaufgrOssd872OZzq32TQ8fyprE82aK8FV7MbxceU7g@mail.gmail.com>
	<20130705184031.67afd669@f163.suse.de>
	<1373061027.2261.14.camel@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373061027.2261.14.camel-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Yes - I noticed that too (although with David's patch at least it is
better).  For the POSIX case for readdir we are ok, but for the
non-posix case for readdir there is are only two infolevels, one too
big and one too small (FILE_STANDARD_INFORMATION) that seem to return
nlinks so we should be setting them to default values if we can't get
them from the server (ie if cf_attr->nlink is 0).  This patch should
fix it by catching it when we are about to update the inode to make
sure we are putting a legal value in (I have not tested it yet).
Thoughts on this minor followon patch?

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 449b6cf..8329c18 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -134,7 +134,13 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr
        inode->i_mtime = fattr->cf_mtime;
        inode->i_ctime = fattr->cf_ctime;
        inode->i_rdev = fattr->cf_rdev;
-       set_nlink(inode, fattr->cf_nlink);
+       /* number of links on a directory is at least 2, at least 1 for file */
+       if ((fattr->cf_cifsattrs & ATTR_DIRECTORY) && (fattr->cf_nlink < 2))
+               set_nlink(inode, 2);
+       else if (fattr->cf_nlink < 1)
+               set_nlink(inode, 1);
+       else
+               set_nlink(inode, fattr->cf_nlink);
        inode->i_uid = fattr->cf_uid;
        inode->i_gid = fattr->cf_gid;


On Fri, Jul 5, 2013 at 4:50 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2013-07-05 at 18:40 +0200, David Disseldorp wrote:
>> On Thu, 4 Jul 2013 14:43:23 -0500
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > I merged an equivalent but slightly smaller version of your patch into
>> > cifs-2.6.git (see below) and added stable since we should not be
>> > returning nlink of 0.  Let me know if any objections.
>>
>> Looks good to me Steve.
>> FWIW, I've been using the following patch to replicate the
>> NumberOfLinks=0 behaviour on Samba:
>> http://gitweb.samba.org/?p=ddiss/samba.git;a=commitdiff;h=93c8795c9a9e9f
>>
>> Cheers, David
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> I'm sorry, this patch is incomplete.
>
> It ignores the readdir codepath completely. If Steve has already merged
> this, then it needs a follow-on patch that fixes the readdir code too,
> probably with the same workaround in cifs_fill_common_info.
>
> Otherwise, you're going to end up with different st_nlink values
> depending on whether it got instantated by a readdir() or stat().
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



-- 
Thanks,

Steve

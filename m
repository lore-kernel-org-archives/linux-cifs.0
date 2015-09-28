From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: fix encryption error checks on mount
Date: Mon, 28 Sep 2015 16:07:25 -0500
Message-ID: <CAH2r5muU9tr6-EOc845k8vf7Og-pNafSuZQM7kBACZ_e++DHeQ@mail.gmail.com>
References: <20150928100157.GC11367@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928100157.GC11367@mwanda>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Good catch.  Fix pushed to cifs-2.6.git for-next branch

https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=ff9f84b7d79ddccab4c293c9d3e289f95ae594f7

On Mon, Sep 28, 2015 at 5:01 AM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> Hello Steve French,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 88627148400e: "fix encryption error checks on mount" from
> Sep 22, 2015, leads to the following Smatch complaint:
>
> fs/cifs/smb2pdu.c:948 SMB2_tcon()
>          warn: variable dereferenced before check 'tcon' (see line 926)
>
> fs/cifs/smb2pdu.c
>    922          if (tcon && tcon->bad_network_name)
>                     ^^^^
> Old code assumes "tcon" can be NULL.
>
>    923                  return -ENOENT;
>    924
>    925          if ((tcon->seal) &&
>                      ^^^^^^^^^^
> Patch adds unchecked dereference.
>
>    926              ((ses->server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION) == 0)) {
>    927                  cifs_dbg(VFS, "encryption requested but no server support");
>    928                  return -EOPNOTSUPP;
>    929          }
>    930
>    931          unc_path = kmalloc(MAX_SHARENAME_LENGTH * 2, GFP_KERNEL);
>    932          if (unc_path == NULL)
>    933                  return -ENOMEM;
>    934
>    935          unc_path_len = cifs_strtoUTF16(unc_path, tree, strlen(tree), cp) + 1;
>    936          unc_path_len *= 2;
>    937          if (unc_path_len < 2) {
>    938                  kfree(unc_path);
>    939                  return -EINVAL;
>    940          }
>    941
>    942          rc = small_smb2_init(SMB2_TREE_CONNECT, tcon, (void **) &req);
>    943          if (rc) {
>    944                  kfree(unc_path);
>    945                  return rc;
>    946          }
>    947
>    948          if (tcon == NULL) {
>                     ^^^^^^^^^^^^
> Another check for NULL.
>
>    949                  /* since no tcon, smb2_init can not do this, so do here */
>    950                  req->hdr.SessionId = ses->Suid;
>
> regards,
> dan carpenter



-- 
Thanks,

Steve

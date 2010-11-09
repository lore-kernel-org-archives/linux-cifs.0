From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Source code of SMB2 Kernel module
Date: Mon, 8 Nov 2010 22:05:34 -0600
Message-ID: <AANLkTikeNCCoMTsnaMMs6jqivgbke9hTUx_25hosM=-9@mail.gmail.com>
References: <4CC65859.7040100@nttcom.co.jp>
	<4CC6642F.2040401@suse.de>
	<4CCA6FD3.4060907@nttcom.co.jp>
	<4CCA7177.40303@suse.de>
	<4CCF5DF8.9030809@nttcom.co.jp>
	<4CD12521.2020708@suse.de>
	<4CD35A27.4050605@nttcom.co.jp>
	<AANLkTinm718oZX2Qc4++W_CYkv0+RZRwr09Uzu4zcDn0@mail.gmail.com>
	<4CD76751.8010700@nttcom.co.jp>
	<AANLkTimx3ukvAjmuf5KQ3dSLVhpaF51pXcOfS1E_iFhY@mail.gmail.com>
	<4CD784AB.3040805@suse.de>
	<4CD8C4E6.5080603@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD8C4E6.5080603-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Nov 8, 2010 at 9:49 PM, Shinnosuke Yagi
<yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org> wrote:
> Thank you, Suresh and Steve.
>
>
> Fscache was loaded, but smb2 module was not loaded successfully.
> Nothing was displayed when I did
>>
>> =A0 lsmod | grep smb2
>
> From Dmesg, following messages were displayed.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> FS-Cache: Netfs 'smb2' registered for caching
> FS-Cache: Netfs 'smb2' unregistered from caching
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>
> Does this means FS-Cache on this kernel doesn't support smb2?

That is probably not the problem.   Seems like init_smb2 is failing.
Perhaps a problem registering the required key types.

You could enable debug messages to see if additional info is logged
to dmesg

e.g.

stevef@stevef-laptop:~/smb2$ git diff -a
diff --git a/fs/smb2/smb2fs.c b/fs/smb2/smb2fs.c
index aa550a3..8cc1245 100644
--- a/fs/smb2/smb2fs.c
+++ b/fs/smb2/smb2fs.c
@@ -57,7 +57,7 @@ static struct quotactl_ops smb2_quotactl_ops;

 /* Definitions of various global variables follow */

-int smb2FYI;
+int smb2FYI =3D 1;
 int smb2ERROR =3D 1;
 int trace_SMB2;



Alternatively you could add some logging (e.g. printk statements)
to the error goto statements in this section of smb2fs.c (smb2_init)

        rc =3D smb2_fscache_register();
        if (rc)
                goto out_clean_proc;

        rc =3D smb2_init_inodecache();
        if (rc)
                goto out_unregister_fsc;

        rc =3D smb2_init_mids();
        if (rc)
                goto out_destroy_inodecache;

        rc =3D smb2_init_request_bufs();
        if (rc)
                goto out_destroy_mids;

        rc =3D register_filesystem(&smb2_fs_type);
        if (rc)
                goto out_destroy_request_bufs;

        rc =3D register_key_type(&smb2_spnego_key_type);



--=20
Thanks,

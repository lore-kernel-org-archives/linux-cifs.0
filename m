From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] /fs/cifs/cifssmb.c (2.6.35.5): Simple pointer initialization
Date: Sun, 26 Sep 2010 16:11:44 -0500
Message-ID: <AANLkTikALD7KU9aiRbFWvggM3yDz4tHvjfy-KRCOMAsm@mail.gmail.com>
References: <945403.85622.qm@web45802.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Poyo VL <poyo_vl-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <945403.85622.qm-K0ZMcrTUAwnrNpU5RS+xBlZ8N9CAUha/QQ4Iyu8u01E@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Seems that it makes it more confusing? - if null were a valid value
for pdata we would need to check for this later in the function before
the memcpy

It didn't throw that error on my gcc version - is your gcc older or do
you use different compile options or different arch?

On Sun, Sep 26, 2010 at 6:05 AM, Poyo VL <poyo_vl-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
> When I tried to compile the kernel (make allyesconfig) I got the foll=
owing ugly
> warning:
> fs/cifs/cifssmb.c: In function =91CIFSSMBGetCIFSACL=92:
> fs/cifs/cifssmb.c:3082: warning: =91pdata=92 may be used uninitialize=
d in this
> function
> The pdata pointer is prctically initialized in line 3086 and it is us=
ed in line
> 3122, but the compiler can't be sure that pdata will be used initiali=
zed so it
> throws that ugly warning. Just initializing *pdata with NULL will get=
 rid off
> that warning.
> Patch downer. I also attached it because someone told me that there a=
re problems
> with Yahoo! Mail, it trims spaces or tabs...
>
> Signed-off-by: Ionut Gabriel Popescu <poyo_vl-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> ---
>
> --- a/fs/cifs/cifssmb.c =A0 =A02010-09-20 23:59:09.000000000 +0300
> +++ b/fs/cifs/cifssmb.c =A0 =A02010-09-26 13:05:45.281241095 +0300
> @@ -3079,7 +3079,7 @@ CIFSSMBGetCIFSACL(const int xid, struct
> =A0 =A0 =A0 =A0 __u32 parm_len;
> =A0 =A0 =A0 =A0 __u32 acl_len;
> =A0 =A0 =A0 =A0 struct smb_com_ntransact_rsp *pSMBr;
> - =A0 =A0 =A0 =A0char *pdata;
> + =A0 =A0 =A0 =A0char *pdata =3D NULL;
>
> =A0/* validate_nttransact */
> =A0 =A0 =A0 =A0 rc =3D validate_ntransact(iov[0].iov_base, (char **)&=
parm,
>
>
>



--=20
Thanks,

Steve

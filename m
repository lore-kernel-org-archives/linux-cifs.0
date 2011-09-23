From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] manpage: document sec=ntlmssp(i) and clean up discussion
 of signing (try #2)
Date: Fri, 23 Sep 2011 10:21:58 -0500
Message-ID: <CADT32eJJ++SO9V-TFX0VZkMzpEjZFf16L03s9nWCVGj+rg=UpA@mail.gmail.com>
References: <1316791051-5057-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316791051-5057-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 23, 2011 at 10:17 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> This version incorporates Shirish's comments about consistency and wo=
rding.
>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0mount.cifs.8 | =A0 30 ++++++++++++++++++++++++++----
> =A01 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 64a8b64..81ebdbe 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -326,7 +326,7 @@ krb5 Use Kerberos version 5 authentication
> =A0.sp -1
> =A0.IP \(bu 2.3
> =A0.\}
> -krb5i Use Kerberos authentication and packet signing
> +krb5i Use Kerberos authentication and forcibly enable packet signing
> =A0.RE
> =A0.sp
> =A0.RS 4
> @@ -348,7 +348,7 @@ ntlm Use NTLM password hashing (default)
> =A0.sp -1
> =A0.IP \(bu 2.3
> =A0.\}
> -ntlmi Use NTLM password hashing with signing (if /proc/fs/cifs/Packe=
tSigningEnabled on or if server requires signing also can be the defaul=
t)
> +ntlmi Use NTLM password hashing and force packet signing
> =A0.RE
> =A0.sp
> =A0.RS 4
> @@ -370,10 +370,32 @@ ntlmv2 Use NTLMv2 password hashing
> =A0.sp -1
> =A0.IP \(bu 2.3
> =A0.\}
> -ntlmv2i Use NTLMv2 password hashing with packet signing
> +ntlmv2i Use NTLMv2 password hashing and force packet signing
> +.RE
> +.sp
> +.RS 4
> +.ie n \{\
> +\h'-04'\(bu\h'+03'\c
> +.\}
> +.el \{\
> +.sp -1
> +.IP \(bu 2.3
> +.\}
> +ntlmssp Use NTLMv2 password hashing encapsulated in Raw NTLMSSP mess=
age
> +.RE
> =A0.sp
> +.RS 4
> +.ie n \{\
> +\h'-04'\(bu\h'+03'\c
> +.\}
> +.el \{\
> +.sp -1
> +.IP \(bu 2.3
> +.\}
> +ntlmsspi Use NTLMv2 password hashing encapsulated in Raw NTLMSSP mes=
sage, and force packet signing
> =A0.RE
> -[NB This [sec parameter] is under development and expected to be ava=
ilable in cifs kernel module 1\&.40 and later]
> +.sp
> +If the server requires signing during protocol negotiation, then it =
may be enabled automatically. Packet signing may also be enabled automa=
tically if it's enabled in /proc/fs/cifs/SecurityFlags.
> =A0.RE
> =A0.PP
> =A0nobrl
> --
> 1.7.6.2
>
>

Looks correct to me.
Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

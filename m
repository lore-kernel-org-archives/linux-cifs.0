From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] manpage: document sec=ntlmssp(i) and clean up discussion
 of signing
Date: Fri, 23 Sep 2011 10:11:40 -0500
Message-ID: <CADT32eKA66VSr6znDqezMp9cdggZ+pwLtOnCJeqC62pi06dArQ@mail.gmail.com>
References: <1316789759-4314-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1316789759-4314-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 23, 2011 at 9:55 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0mount.cifs.8 | =A0 26 ++++++++++++++++++++++++--
> =A01 files changed, 24 insertions(+), 2 deletions(-)
>
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 64a8b64..48f9312 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -348,7 +348,7 @@ ntlm Use NTLM password hashing (default)
> =A0.sp -1
> =A0.IP \(bu 2.3
> =A0.\}
> -ntlmi Use NTLM password hashing with signing (if /proc/fs/cifs/Packe=
tSigningEnabled on or if server requires signing also can be the defaul=
t)
> +ntlmi Use NTLM password hashing with signing

Nitpicking, perhaps this should be 'packet signing' instead
of just 'signing' to be consistent with other such phrases.

> =A0.RE
> =A0.sp
> =A0.RS 4
> @@ -371,9 +371,31 @@ ntlmv2 Use NTLMv2 password hashing
> =A0.IP \(bu 2.3
> =A0.\}
> =A0ntlmv2i Use NTLMv2 password hashing with packet signing
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
> +ntlmssp Use NTLMv2 password hashing encapsulated in NTLMSSP message

Not sure whether we need to even mention that this is Raw NTLMSSP

> +\h'-04'\(bu\h'+03'\c
> +.\}
> +.el \{\
> +.sp -1
> +.IP \(bu 2.3
> +.\}
> +ntlmsspi Use NTLMv2 password hashing encapsulated in NTLMSSP message=
 and enable packet signing
> =A0.RE
> -[NB This [sec parameter] is under development and expected to be ava=
ilable in cifs kernel module 1\&.40 and later]
> +.sp
> +If the server requires signing during protocol negotiation, then it =
may be enabled automatically. Signing may also be enabled automatically=
 if it's enabled in /proc/fs/cifs/SecurityFlags.
> =A0.RE
> =A0.PP
> =A0nobrl
> --
> 1.7.6.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

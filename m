From: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH v2][cifs-utils] manpage: document the mount.cifs vers=
 option
Date: Tue, 19 Mar 2013 16:49:05 +0000
Message-ID: <614F550557B82C44AC27C492ADA391AA04606FB9@TK5EX14MBXC285.redmond.corp.microsoft.com>
References: <1363703710-23683-1-git-send-email-jlayton@samba.org>
 <1363708534-25460-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363708534-25460-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> -----Original Message-----
> From: Jeff Layton [mailto:jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org] On Behalf Of Jeff Layton
> Sent: Tuesday, March 19, 2013 11:56 AM
> To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Tom Talpey
> Subject: [PATCH v2][cifs-utils] manpage: document the mount.cifs vers=
> option
> 
> Thanks to Tom Talpey for clarifying some of the info here.
> 
> Cc: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.8 | 51
> +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/mount.cifs.8 b/mount.cifs.8 index a4fdd98..1cd2de5 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -539,6 +539,57 @@ prefixpath=
>  It's possible to mount a subdirectory of a share. The preferred way to do this
> is to append the path to the UNC when mounting. However, it's also possible
> to do the same by setting this option and providing the path there.
>  .RE
>  .PP
> +vers=
> +.RS 4
> +SMB protocol version. Allowed values are:
> +.sp
> +.RS 4
> +.ie n \{\
> +\h'-04'\(bu\h'+03'\c
> +.\}
> +.el \{\
> +.sp -1
> +.IP \(bu 2.3
> +.\}
> +1.0 - The classic CIFS/SMBv1 protocol. This is the default.
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
> +2.0 - The SMBv2.0 protocol that was introduced in Microsoft Windows Vista

Vista *Service Pack 1*. Vista RTM, which speaks dialect 2.000, only interoperates
with itself. Unless the cifs.ko client speaks 2.000 - does it? Not recommended!

Tom.

> and Windows Server 2008. Note that the dialect number in the on-the-wire
> protocol with this version is technically "2.002".
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
> +2.1 - The SMBv2.1 protocol that was introduced in Microsoft Windows 7 and
> Windows Server 2008R2.
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
> +3.0 - The SMBv3.0 protocol that was introduced in Microsoft Windows 8 and
> Windows Server 2012.
> +.RE
> +.PP
> +Note too that while this option governs the protocol version used, not all
> features of each version are available.
> +.RE
> +.PP
>  \-\-verbose
>  .RS 4
>  Print additional debugging information for the mount\&. Note that this
> parameter must be specified before the \-o\&. For example:
> --
> 1.7.11.7

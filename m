From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 30/45] CIFS: Enable signing in SMB2
Date: Tue, 21 Aug 2012 18:01:01 +0400
Message-ID: <CAKywueQaO36DsyJ9Q_pea0-YHcDSUT4u6VFo8D=ubXkLe9GPNQ@mail.gmail.com>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
	<1342626541-29872-31-git-send-email-pshilovsky@samba.org>
	<k0vdnf$434$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <k0vdnf$434$1@ger.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/8/21 Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> Hi Pavel,
>
>> Use hmac-sha256 and rather than hmac-md5 that is used for CIFS/SMB.
>>
>> Signature field in SMB2 header is 16 bytes instead of 8 bytes.
>
> Sorry for the late reply, I just found a reference to this patch...

No problem, thank you for your comments.

>
> To me it seems that this patch doesn't take care of the fact that
> the signing key in SMB2/3 belongs to the session and not to the transport
> connection.

Yes, you are right. Thanks to this point. I think we can fix this later.

>
> Does the SMB2 code support multiuser mounts yet?

No, SMB2 code doesn't support Kerberos auth and multiuser mounts yet.

>
> Why are you using some "BSRSPYL " magic? I only saw that from Windows
> clients
> using SMB1. (Note: that servers just echo the signature from the
> request, if they don't do signing).
>

(CC'ing Shirish, as the original author of the patch.)

-- 
Best regards,
Pavel Shilovsky.

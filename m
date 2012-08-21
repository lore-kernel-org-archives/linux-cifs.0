From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 30/45] CIFS: Enable signing in SMB2
Date: Tue, 21 Aug 2012 09:58:38 -0500
Message-ID: <CADT32e+4DSN=CSCbL+8GoRePknpD3X0HSq1hjVsXf3KHXQcmTw@mail.gmail.com>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
	<1342626541-29872-31-git-send-email-pshilovsky@samba.org>
	<k0vdnf$434$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <k0vdnf$434$1@ger.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Aug 21, 2012 at 2:35 AM, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Hi Pavel,
>
>> Use hmac-sha256 and rather than hmac-md5 that is used for CIFS/SMB.
>>
>> Signature field in SMB2 header is 16 bytes instead of 8 bytes.
>
> Sorry for the late reply, I just found a reference to this patch...
>
> To me it seems that this patch doesn't take care of the fact that
> the signing key in SMB2/3 belongs to the session and not to the transport
> connection.

metze, where do you see that?  This is the signing key that is used to generate
signature, server->session_key.response.

>
> Does the SMB2 code support multiuser mounts yet?
>
> Why are you using some "BSRSPYL " magic? I only saw that from Windows
> clients
> using SMB1. (Note: that servers just echo the signature from the
> request, if they don't do signing).

IIRC, Jeff Layton added that code to encode BSRSPYL magic (string).
I could be wrong, it has been a while.
But, I do think this is a problem, signature in a smb message is not even
checked till key exchange handshake is session setup is done, right?

>
> metze
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

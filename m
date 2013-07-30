From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NTLMSSP unix query info problem
Date: Mon, 29 Jul 2013 22:55:46 -0500
Message-ID: <CADT32eKTZgH0Tk9YJ9P2eZ_E8k6S9sye89d6syDTprgcP1dB+Q@mail.gmail.com>
References: <CAKywueTz3hRCgFB00dGPE3Bo2mnPN_efZCtzc-yc4c6umg0pUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTz3hRCgFB00dGPE3Bo2mnPN_efZCtzc-yc4c6umg0pUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Pavel, does this happen for smb as well as for smb2 also?
Not sure how can authentication mechanism affect accessibility
(since ntlmssp uses ntlmv2 underneath anyway!)

Regards,

Shirish

On Mon, Jul 29, 2013 at 11:41 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> For sec=ntlmssp unix query path info call returns OK for a
> non-existing uppercase filename if a lowercase one exists. E.g.: stat
> ABC return info about 'abc' file.
>
> But for sec=ntlmv2 or sec=ntlm this call fails with
> STATUS_OBJECT_NAME_NOT_FOUND error code.
>
> This difference was found on upgrade from v3.7 to v3.8 kernel due to
> changing the default security mechanism to NTLMSSP.
>
> Any thoughts on this?
>
> --
> Best regards,
> Pavel Shilovsky.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

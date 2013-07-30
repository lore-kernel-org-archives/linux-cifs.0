From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NTLMSSP unix query info problem
Date: Tue, 30 Jul 2013 09:19:21 +0400
Message-ID: <CAKywueTOzbS_y0hgAjimjP6eXUaRhdBuveOusAaUxnusF-NunA@mail.gmail.com>
References: <CAKywueTz3hRCgFB00dGPE3Bo2mnPN_efZCtzc-yc4c6umg0pUQ@mail.gmail.com>
	<CADT32eKTZgH0Tk9YJ9P2eZ_E8k6S9sye89d6syDTprgcP1dB+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKTZgH0Tk9YJ9P2eZ_E8k6S9sye89d6syDTprgcP1dB+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/7/30 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Pavel, does this happen for smb as well as for smb2 also?
> Not sure how can authentication mechanism affect accessibility
> (since ntlmssp uses ntlmv2 underneath anyway!)
>

SMB2 uses ntlmssp only and testing shows that stat 'ABC' return OK for
'abc' file on such share. Another interesting thing is that SMB2
Create Request for 'ABC' succeeds for 'abc' too but SMB1 NtCreateAndX
returns STATUS_OBJECT_NAME_NOT_FOUND (both for sec=ntlmssp).

-- 
Best regards,
Pavel Shilovsky.

From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3 10/16] CIFS: Use multicredits for SMB 2.1/3 writes
Date: Mon, 28 Jul 2014 11:36:58 +0400
Message-ID: <CAKywueQa8toYf=-XAu_tM12ZSkUiSnc4Pke_sDMpbBP5mXkMEg@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
	<1405957558-18476-11-git-send-email-pshilovsky@samba.org>
	<CADT32e+E5C6gh2+qAt6K6D3NEOx7fZFrWn2sN4Ovs5evQjuW5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+E5C6gh2+qAt6K6D3NEOx7fZFrWn2sN4Ovs5evQjuW5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-07-25 5:06 GMT+04:00 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Looks correct.
>
> Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

Thank you for reviewing the series!

> Only  comment would be, wish there was a mnemonic/define for
> a regular op  when calling add_credits_and_wake_if() for optype
> such as CIFS_ECHO_OP or CIFS_OPBREAK_OP instead of 0.

Yes, it can make sense but should be in another patch/series.

> Oh and super nitpick...  s/reseted/reset/.

Ok, will fix it in my smb2-dev branch on git.altlinux.org.

-- 
Best regards,
Pavel Shilovsky.

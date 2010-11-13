From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mounting share on non-standard ports
Date: Sat, 13 Nov 2010 11:06:53 +0300
Message-ID: <AANLkTinCcUp8Ga41Ustg_JwBks4E-6P85joO_H-GjqOa@mail.gmail.com>
References: <1289321425-7860-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289321425-7860-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/9 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> This patch fixes the following situation: we have the share (1) mounted
> with a non-standard port and try to mount another share (2) with the standard
> one (not specifying the port), the client doesn't connect to the new share (2)
> and returns with existing connection (1). The patch also makes the client
> prevent connecting to a wrong share on a reconnect if the client fails during
> the re-establishing connection to a lost share.

What's about this patch?

-- 
Best regards,
Pavel Shilovsky.

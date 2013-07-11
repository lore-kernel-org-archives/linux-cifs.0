From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS-related deadlock in 3.10-rc7
Date: Thu, 11 Jul 2013 22:08:15 +0400
Message-ID: <CAKywueR=tAUJzfwnB0d6af-DPJwmpuihAtN=NmNfy4GKaZf37w@mail.gmail.com>
References: <CAN_LGv2zhu3zWd+7Jmi9FZd728W5T5kte2P0FMWABzENmyKJ5w@mail.gmail.com>
	<CAKywueQXGN+W6eMyZ-eQD+pCpgRz86Dpxht+YiMVKAGXVebPFg@mail.gmail.com>
	<CAH2r5mt5GH=6624e4t9hELmkR+H0t20+C1Fvrv_o-=nGm5nS=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Alexander E. Patrakov" <patrakov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt5GH=6624e4t9hELmkR+H0t20+C1Fvrv_o-=nGm5nS=A@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/7/11 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Wouldn't this be a candidate for stable?

 Yes, I think it should go to stable as well as "[PATCH 1/8] CIFS: Fix
lease context buffer parsing" patch.

--
Best regards,
Pavel Shilovsky.

From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Make echo interval tunable.
Date: Thu, 17 Dec 2015 01:10:17 -0600
Message-ID: <CAFB9KM3u4+88inSVPfdj0hAezwvKRqtx52q1qWJe=GfoZ1+_Xg@mail.gmail.com>
References: <1450097226-20815-1-git-send-email-sprabhu@redhat.com>
	<CAH2r5mu1xKmd+cg33ti7UtBWpj9XCt5SL0B=7QnV4LDxw-79vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mu1xKmd+cg33ti7UtBWpj9XCt5SL0B=7QnV4LDxw-79vw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Dec 16, 2015 at 10:37 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Why restrict the echo interval to such a narrow range?  If tunable
> might as well allow a larger range, maybe 1 to 600 (ten minutes)?  I
> am not certain of the range of possible future uses - maybe a
> pseudo-real type workload connected to a really fast server wants
> something really low (a few seconds?) and maybe very poor network
> connections want something longer?  Not a strong objection, but seems
> like we could allow a broader range without confusing the user.
>
> Many years ago, Windows and OS/2 had an oplock break time (which also
> controlled how long to wait for acks to come back from the server) -
> and it ranged from 34 to 127 seconds for acks and 35 to 640 for oplock
> break timeouts.     Don't see any reason to limit it less than that
> (that was really old and networks vary a lot in performance now).
>
> Thoughts?

For context, were those timeouts for when broadcasts and signaling
were over three protocols (IPX, IP, and NetBEUI?  I can't recall, but
Chris H. was telling tales of yore last month at a dinner and IIRC the
propagation for SMB was over three protocols because usually at least
one would eventually reach remote hosts under most conditions)?  I
have no issue with long timeouts, but what was the historical context
of the 10 minute oplock breaks?  Forgive me if I'm recalling
incorrectly, but I thought that the extended timeouts were for
much-less-than-optimal conditions over multiple protocols attached to
hubs.

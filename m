From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: First steps towards using socket callbacks: Elimination of the cifs_demultiplex_thread
Date: Sun, 5 Aug 2012 20:26:29 -0700
Message-ID: <CACyXjPwsRhCjmt1R3EWbuYEPkcOvT45h9t+f09Sg8zFcWnWrDQ@mail.gmail.com>
References: <CACyXjPyvo++C4JRpvK_RtBPK846+N02WFqanUtqOMUOL0MEMKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPyvo++C4JRpvK_RtBPK846+N02WFqanUtqOMUOL0MEMKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 5, 2012 at 4:18 PM, Richard Sharpe
<realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi folks,
>
> I think it is possible to convert the CIFS code to using the socket
> callbacks in a step-by-step process.
>
> It seems possible to eliminate the cifs_demultiplex_thread by using
> the sk_data_ready callback on the socket structure
> (server->ssocket->sk) to drive the receipt of incoming data on the TC=
P
> connection and have the callback drive the processing that is done in
> the main loop of the cifs_demultiplex_thread.
>
> Obviously, there will be a number of details to get correct, and in
> particular, the handling of socket errors and reconnect might take
> some work because we are called in a different context than the threa=
d
> context.
>
> This would also seem to allow me to unite the RDMA case if I ever get
> to that ...
>
> However, what I worry about is the possibility of stalls/deadlocks.

I think I will also have to use the sk_state_change callback to handle
connections that have gone away, and then queue work to a workqueue to
process things like cifs_reconnect.

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)

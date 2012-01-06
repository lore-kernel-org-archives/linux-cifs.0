From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs speed problems
Date: Fri, 6 Jan 2012 14:41:40 -0500
Message-ID: <20120106144140.239a83bc@tlielax.poochiereds.net>
References: <4EFDE456.5040108@inf.ethz.ch>
	<20120102064838.682c2c70@tlielax.poochiereds.net>
	<4F074BB8.90302@inf.ethz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Schindler <bschindler-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F074BB8.90302-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 6 Jan 2012 20:30:00 +0100
Benjamin Schindler <bschindler-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org> wrote:

> Hi
> 
> Ah, I thought its already in 3.1 - I just tried and its much better. I 
> can now do the same transfer in about 9 seconds. nfs is with 7-8 secs 
> still faster, but I think I can live with that
> 
> Thank you
> Benjamin
> 
> On 02.01.2012 12:48, Jeff Layton wrote:
> > On Fri, 30 Dec 2011 17:18:30 +0100
> > Benjamin Schindler<bschindler-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>  wrote:
> >
> >> When copying from nas to a windows machine, I get a
> >> healthy 80-100mb/sec.
> > You may want to try a 3.2-rc kernel. We just added async read support in
> > 3.2 which should increase throughput.
> >
> 

(re-cc'ing linux-cifs list)

No problem. Unfortunately, we're somewhat hamstrung by the protocol
when talking to standard cifs servers, so there's not a lot we can
do to make it go faster.

Depending on the number of concurrent requests that the server will
allow, you may be able to get the speed up even more.

Once Steve does his promised patch to make the client respect the
MaxRequests value that the server sends during the protocol
negotiation, that may increase the concurrency and hence the throughput.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

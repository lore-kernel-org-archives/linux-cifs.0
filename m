From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs speed problems
Date: Mon, 2 Jan 2012 06:48:38 -0500
Message-ID: <20120102064838.682c2c70@tlielax.poochiereds.net>
References: <4EFDE456.5040108@inf.ethz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Benjamin Schindler <bschindler-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EFDE456.5040108-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 30 Dec 2011 17:18:30 +0100
Benjamin Schindler <bschindler-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org> wrote:

> When copying from nas to a windows machine, I get a 
> healthy 80-100mb/sec.

You may want to try a 3.2-rc kernel. We just added async read support in
3.2 which should increase throughput.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

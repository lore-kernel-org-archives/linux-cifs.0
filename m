From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: last patches for 3.0
Date: Wed, 6 Jul 2011 14:19:31 -0400
Message-ID: <20110706141931.23c4182b@tlielax.poochiereds.net>
References: <CAH2r5mshrJRCLc-UsY0CGT_Y5Hsfh1-mUmrqH9o9V3FbSBNqwA@mail.gmail.com>
	<20110706135012.18dda5b1@tlielax.poochiereds.net>
	<CAH2r5msT7rTAzN8XJOwYYTAqkJmiJqu_XMEh+M0u=NprOFVA5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msT7rTAzN8XJOwYYTAqkJmiJqu_XMEh+M0u=NprOFVA5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 6 Jul 2011 13:14:10 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I agree that a mount option to override maxmpx would be useful
> (and preferable to the existing module param - a default value overridable
> at insmod time is harder than at mount time) - especially useful to Samba
> server which IIRC can handle more than 50 simultaneous requests
> but does not advertise this support in its negotiate response.
> 

That value appears to be settable on samba via "max mux", but I have no
idea how windows clients will behave in the face of a large value there.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

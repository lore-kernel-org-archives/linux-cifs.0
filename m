From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Should multiuser imply "noperm" mount option?
Date: Thu, 13 Oct 2011 14:34:09 -0400
Message-ID: <20111013143409.7b4ec34a@barsoom.rdu.redhat.com>
References: <CAH2r5mvEq3nrx=Qu0gkn9Oaa-WYK-EuJqqNKYLQOY4QmsrgHXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvEq3nrx=Qu0gkn9Oaa-WYK-EuJqqNKYLQOY4QmsrgHXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 13 Oct 2011 13:12:20 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> If multiuser mount is enabled and we are getting and sending the
> "correct" credentials - should we enable noperm by default (so we
> don't do client side permission checking unless we are mounted as
> single user - no multiuser)
> 

It already does that. From the multiuser section of the
mount.cifs manpage:

          "With this change, it's feasible for the server to handle
           permissions enforcement, so this option also implies "noperm"."

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

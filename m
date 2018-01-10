From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Can I reduce the CIFS client connection timeout?
Date: Wed, 10 Jan 2018 10:42:27 +0530
Message-ID: <CAMcOejUEP_AUvoOX8bRNx6JbLjjSHBag7TuO_+j=88hyh_b69A@mail.gmail.com>
References: <CA+BABmYNvYW48pXnSkqGnpO9yj3oLb1jf1MPXbNcVJi+3a6sRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Josh Pettett <jpettett-qZWgbgh2FR7QT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+BABmYNvYW48pXnSkqGnpO9yj3oLb1jf1MPXbNcVJi+3a6sRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Josh,

The client will wait 2 * echo interval before marking a server
unresponsive. The default echo interval is set to 60 seconds. You can
tune this to a lower value using the echo_interval=n mount option. In
your case, you can set echo_interval to 8 so that the server is marked
unresponsive after 15 seconds of the server being unavailable.

Upstream patch which added this option.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=adfeb3e00e8e1b9fb4ad19eb7367e7c272d16003

Explanation of the code before that patch was added:
http://sprabhu.blogspot.in/2015/08/investigation-into-effects-of-server.html

Sachin Prabhu

On Thu, Jan 4, 2018 at 11:15 AM, Josh Pettett <jpettett-qZWgbgh2FR7QT0dZR+AlfA@public.gmane.org> wrote:
> Hello,
>
> We have a use case in which we want the the CIFS mount to quickly
> timeout and return an error on the client side if the remote server is
> down.  This error would then trigger failure-mode logic in our
> application. It appears that an error is returned if the server is
> unreachable for 120 seconds, but we want the timeout to occur after
> about 15 seconds.  Is this value configurable anywhere?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

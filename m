From: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Fri, 26 Aug 2011 19:16:28 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1108261914250.2203@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <3300.1313637592@jrobl> <alpine.DEB.2.02.1108180632000.10458@p34.internal.lan> <alpine.DEB.2.02.1108180807070.7903@p34.internal.lan> <alpine.DEB.2.02.1108180821440.7903@p34.internal.lan>
 <20110818091140.385a9455@barsoom.rdu.redhat.com> <alpine.DEB.2.02.1108180914180.7903@p34.internal.lan> <20110818130408.71c55b96@barsoom.rdu.redhat.com> <alpine.DEB.2.02.1108181314310.7903@p34.internal.lan> <CAH2r5mvNkUWh0rYTbTEWmUPiRsxUbmrGNpTOaebiG0CCKRfA1g@mail.gmail.com>
 <alpine.DEB.2.02.1108181331180.7903@p34.internal.lan> <CAH2r5msTpKdxwpgG+-3-gkkr5h7Ox1tL86q3LyTBMd1V8WS7aQ@mail.gmail.com> <alpine.DEB.2.02.1108181413030.7903@p34.internal.lan> <20110818145257.035a38e9@barsoom.rdu.redhat.com> <20110826175940.2830044d@tlielax.poochiereds.net>
 <alpine.DEB.2.02.1108261844170.2203@p34.internal.lan> <CAH2r5mtrUq4aTHgqRyG-YZZoUztU4_k4rh+nXrN13CVckex8ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"J. R. Okajima" <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>,
	Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtrUq4aTHgqRyG-YZZoUztU4_k4rh+nXrN13CVckex8ZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



On Fri, 26 Aug 2011, Steve French wrote:

> Fails with Jeff's new 20+ patch series?

Hi,

No, wanted to make sure it still mounted with 3.1-rc2+previous patches before 
doing anything, there have been quite a few patches applied recently on the
Windows host (updates) I'll need to check with the owner tomorrow; I want 
to ensure I can mount as before before applying Jeff's patches.

Justin.

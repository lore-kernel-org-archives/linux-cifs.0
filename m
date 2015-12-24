From: Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Subject: Re: [PATCH] cifs: fix race between call_async() and reconnect()
Date: Thu, 24 Dec 2015 17:07:01 +0100
Message-ID: <20151224160700.GA6309@axis.com>
References: <1450852361-26556-1-git-send-email-rabin.vincent@axis.com>
 <CADT32eL9JHxq-xNQgtgeLgFm9HNKGX32uSH2cVnhrA0bi4uZ8g@mail.gmail.com>
 <CAH2r5mtwbAh7gjVVcbcwe72LXnt_NcCZJUUSfTZGTg2+q=JUhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rabin-66gdRtMMWGc@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtwbAh7gjVVcbcwe72LXnt_NcCZJUUSfTZGTg2+q=JUhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Dec 23, 2015 at 02:37:34PM -0600, Steve French wrote:
> Looks like a stable candidate.
> 
> Opinions?

Yes, please.  I intended to include the CC:stable tag in the patch
submission but forgot to do so.  We've seen the crashes in our testing
so the race is not just theoretical.

Thanks.

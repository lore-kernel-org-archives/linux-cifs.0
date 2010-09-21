From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: linux-next: manual merge of the bkl-vfs tree with the cifs tree
Date: Tue, 21 Sep 2010 09:59:49 +0200
Message-ID: <201009210959.50115.arnd@arndb.de>
References: <20100921161031.7745150e.sfr@canb.auug.org.au> <AANLkTikbM17xs41abm+6DTa9DJLYM8XYeVg=bZr_n8M5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikbM17xs41abm+6DTa9DJLYM8XYeVg=bZr_n8M5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tuesday 21 September 2010, Steve French wrote:
> Alternatively - I could merge the trivially modified bkl cifs patch
> into the cifs-2.6.git tree if that is easier

Well, this is the most trivial sort of conflict, I guess we don't have
to worry about it.

Part of my patch reverts part of an earlier patch in the bkl-vfs series
(by design, not by accident).
We could sort that out, but my feeling is that it's not worth it.

	Arnd

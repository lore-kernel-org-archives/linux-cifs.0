From: Mirko Scholz <mscholz5-2/1ofaGcC4w@public.gmane.org>
Subject: Re: file truncation on newer linux-cifs versions
Date: Sun, 15 Jan 2012 20:04:46 +0100
Message-ID: <20120115190445.GA4008@gwdu05.gwdg.de>
References: <20120113230701.GA3100@gwdu05.gwdg.de> <CAOhYWN+dLLKXs6MU3W88oHzyFgi1KV+7oh1qPh61ZEqUA-Jw8w@mail.gmail.com> <20120114135057.GA4197@gwdu05.gwdg.de> <20120114093322.7e36221d@tlielax.poochiereds.net> <CAH2r5ms9wfz_3dGeCLJ7bvXeKeerSEfFpbiTz6C_WdPbFk6WXA@mail.gmail.com>
Reply-To: mscholz5-2/1ofaGcC4w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5ms9wfz_3dGeCLJ7bvXeKeerSEfFpbiTz6C_WdPbFk6WXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


On Sat, Jan 14, 2012 at 03:46:05PM -0600, Steve French wrote:
> Can you experiment a little with setting different wsize values and see
> if the server's bug starts at exactly 64K, or as we saw with another
> server ~100K.  
Wouldn't the -ENOSPC not appear at that size?  Anyways I tried
68k, 80k and 100k, the problem of truncation remains.

> There is significant performance benefit in setting the wsize to
> larger than 64K, but if we find a second server that maxes at ~100K we
> may want to set it to that.  

> I still would prefer to workaround buggy servers if it were possible
> to recognize them because I hate to punish (with 20%+ or more worse
> write performance) the vast majority of servers (Windows,Samba,
> NetApp) for the bug of a few.
IMHO there are a couple of alternatives, that do not punish other
servers:

educate your users, as

* while elevated logging display a warning when encountering a short
write.  Just that someone without deeper CIFS knowledge gets a hint.

I just didn't follow linux-cifs and haven't been aware of the wsize
option at all, sorry.

or do the workaround

* during negotiation log something like "detected buggy/sub-performant
server, setting wsize to known safe 65536" as at least one NIC driver
did

* go with 64k as default and have a white list of performant servers

Whether you black or white list depends entirely which list is expected
to be more definitive, doesn't it?  As I have no clue how many different
CIFS servers there are, the white list sounds more rational to me.  But
our setup may be a bit special anyways because Blue Arc supports NFS
exports.  IT dept. only objects against shared access.

> I would be curious though if your server gives any indication of write
> error or silently ignores the large write.
Expect an answer during next week.  I myself cannot obtain such
information.

Mirko

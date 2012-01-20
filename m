From: "ralda-Mmb7MZpHnFY@public.gmane.org" <ralda-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: Trouble accessing Buffalo NAS with CIFSFS
Date: Fri, 20 Jan 2012 20:06:26 +0100
Message-ID: <20120120200626.b04b1d40.ralda@gmx.de>
References: <20120119090752.9b7aea6c.ralda@gmx.de>
	<20120119070543.662a3c56@tlielax.poochiereds.net>
	<20120120113042.0fdfea5f.ralda@gmx.de>
	<20120120101938.7ca7464d@tlielax.poochiereds.net>
	<20120120165657.00042c72.ralda@gmx.de>
	<20120120111936.5329cbb4@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120120111936.5329cbb4-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hallo Jeff!

> At this point, I'd suggest just setting the cifs_max_pending module
> parm low  (1 or 2) and seeing if that helps. If it does, then that
> should basically emulate the effect of steve's eventual patch. If it
> doesn't then we'll probably need to have a closer look at why it isn't.

I have set cifs_max_pending to 2 (setting it 1 results in value 2).
Giving interesting results:

Normal mount/cp of single file works (same mount parameter as before).

Copying several files with midnight commander showed me a copy speed of
4.5 to 5.6 MByte per second - start at 4.5 and raising quickly to 5.6).
This speed is higher then ever received on copying to the same NAS
station from same hardware installation. Formerly (kernel 2.6.18
SMBFS) copies startet below 3.5 MBps and raised slowly up to about 4
MBps (or slightly above - only at very big files). So reducing the
setting of cifs_max_pendig not only let the drive work it additionally
gave me a big step in speed optimization.

... but: Switching virtual console during copy process let the copy
stop with a stuck mc as before. The only difference: After killing the
process and a delay of about 2 minutes (felt, not measured) the process
disappeared and NAS drive returned to a working state without system
reboot.

If you like/need I may catch more data for diagnosis tomorrow. Just let
me know what you need and how I shall test. I'm willing to give you all
data for diagnosis I'm able to collect.

--
Harald

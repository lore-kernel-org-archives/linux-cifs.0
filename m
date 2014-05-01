From: Thomas Creutz <thomas.creutz-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: character-problems
Date: Thu, 01 May 2014 13:11:19 +0200
Message-ID: <53622BD7.7030005@gmx.de>
References: <53620CE9.10301@gmx.de>	<CAOhYWNKp1QqsebugYqM2yAqOef4yw=t9tNyUmH-9ds59pjygqw@mail.gmail.com>	<53622687.9030306@gmx.de> <CAOhYWN+PNtQ8HMyi3OFyv3KQ-bbvOKcGFNLZw5Jx2zHNdRJ1LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOhYWN+PNtQ8HMyi3OFyv3KQ-bbvOKcGFNLZw5Jx2zHNdRJ1LQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Am 01.05.2014 12:54, schrieb Jeff Layton:
> Maybe...
>
> For your kernel, what is CONFIG_NLS_DEFAULT set to? I know that ubuntu
> used to set that to iso9959-1, but I think they recently moved to
> using utf8. If it's set to iso8559-1 then that may be related to the
> problem.

No, its not a charset problem.

grep CONFIG_NLS_DEFAULT /boot/config-$(uname -r)
CONFIG_NLS_DEFAULT="utf8"

because I also told, that the file names have the same problem on the
server (uploaded over php-scripts). Some scripts use utf-8 others
iso8...., thats why you will never see all chars right on console/samba
client.
But, this problem should get handelt by samba/cifs... the files are also
useable with a windows client (so the access problem is in the cifs
client, not the samba server)

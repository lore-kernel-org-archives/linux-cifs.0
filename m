From: Ladislav Michl <Ladislav.Michl-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org>
Subject: Adjustable timeout
Date: Tue, 13 Jul 2010 12:48:10 +0200
Message-ID: <20100713104810.GA3001@localhost.localdomain>
Reply-To: Ladislav Michl <ladis-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I'm using network storage for voicemail recording, which works pretty well
on responsive servers. However in case of server crash on malfunction even
open syscall takes ages to return error, which is just unfortunate.

Situation was described in thread "Timeout waaay too long"
http://lists.samba.org/archive/linux-cifs-client/2006-February/001203.html
and now, afer more than four years, it is not any better.

My very problem could be probably solved in userspace with "guard" thread
killing stuck open or write syscall and moving to next storage available,
but I found such a solution unly.

There is interesting notion in post "[PATCH] cifs: hard mount option
behaviour" http://lists.samba.org/archive/linux-cifs-client/2010-June/006291.html
about what is considered a responsive server today.

For now I modified timeouts in SendReceive(2), which improved situation for
me, but the real qustion is, how should widely acceptable solution look like.

Thanks for your suggestions,
	ladis

From: Thomas Creutz <thomas.creutz-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: character-problems
Date: Thu, 01 May 2014 17:08:03 +0200
Message-ID: <53626353.2030103@gmx.de>
References: <53620CE9.10301@gmx.de>	<CAOhYWNKp1QqsebugYqM2yAqOef4yw=t9tNyUmH-9ds59pjygqw@mail.gmail.com>	<53622687.9030306@gmx.de>	<CAOhYWN+PNtQ8HMyi3OFyv3KQ-bbvOKcGFNLZw5Jx2zHNdRJ1LQ@mail.gmail.com>	<53622BD7.7030005@gmx.de> <CAOhYWNL+3+c7nM-zabZ78PK_j5CkuFqOsB66Ej_dk7pcrpM3bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOhYWNL+3+c7nM-zabZ78PK_j5CkuFqOsB66Ej_dk7pcrpM3bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Am 01.05.2014 15:32, schrieb Jeff Layton:
> I'm not sure then.
>
> The client generally uses the same tables to convert between unicode
> and the local charset in both directions. One thing you could do is
> inspect some traces when you're reproducing this problem. Get a
> capture of both the "ls" and the "stat" (or cp) commands. Are the
> unicode names being sent by the server identical to the ones being
> sent by the client?

Ok, and how can I do this? tcpdump or some other debug ways?

From: John Jackson <john.michael.jackson1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: noserverino option
Date: Thu, 3 Sep 2015 11:06:52 -0400
Message-ID: <CAPhxvqOMBJ+2Ph1HT8ggTzacogna15kWQCpsOYVU9JCQD9BhVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Everyone,

How does the noserverino operation behave when mounting a CIFS share,
what does it do?

I know the man page says, Client generates inode numbers itself rather
than using the actual ones from the server,  but how does using the
noserverino option affecting caching of a linux client mounting a
share with cifs from a NAS.


I was recently facing a problem where I had a windows7  machine and a
linux(2.6.32) machine concurrently reading/writing files on a synology
nas box, And the files were mismatched by 4k, one linux page size on
the linux machine. I found that upgrading the kernel to 3.10 or 3.18
and using the noserverino option, my problem had gone away. However, I
am worried I may have taken a performance hit. .


Thank You
John Jackson

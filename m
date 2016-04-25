From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Design of fsnotify for FUSE, nfs and cifs: when/how to send a watch.
Date: Mon, 25 Apr 2016 10:47:40 +0200
Message-ID: <CANXojcy2m9LJC4FKAb6NhZJWQuPJcdTVFzNRJoYR=BKc5rSg9w@mail.gmail.com>
References: <CANXojcz-U4YzgUhDRgvoVX=n756oVg4nvvvwpimmpBJyLkkmoQ@mail.gmail.com>
	<CANXojcwF1ePzsLjpVbPZNdQTO6wG3xh2GQe6fPNJ5H4sZur-mA@mail.gmail.com>
	<CAH2r5mvahP1Vkp+=84O3BntjwNvu4k498S1CjxZ2mhKu8GhDKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvahP1Vkp+=84O3BntjwNvu4k498S1CjxZ2mhKu8GhDKg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I guess with performance you mean the performance of reporting events.
I understand it
can be a performance issue when there are a lot of events.

I haven't tested that yet. The events are received by the userspace
daemon, and if they are not initiated by this daemon self,
they are send to the VFS with just inodenumber, mask and eventually
the name of the entry. There a lookup is done of the inode using
ilookup5, and reported to fsnotify using the common function fsnotify,
defined in fsnotify.c, 190.

Well I know I have to test this by creating and deleting a lot of
files in the watched directory. I will report later.

Stef

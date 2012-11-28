From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 5/5] CIFS: Fix write after setting a read lock for read
 oplock files
Date: Wed, 28 Nov 2012 11:30:43 +0400
Message-ID: <CAKywueQVXWtU_LRK89mqnA_Gph26=xurWCyBkuS7cEaA=emoRQ@mail.gmail.com>
References: <1353999029-3975-1-git-send-email-piastry@etersoft.ru>
	<1353999029-3975-6-git-send-email-piastry@etersoft.ru>
	<CAH2r5mt-cQ4ppzMnhM=9T3ALE5QO4_A6t3P87n8-q=zGutuAOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt-cQ4ppzMnhM=9T3ALE5QO4_A6t3P87n8-q=zGutuAOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/11/27 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Am curious how you noticed this problem?  Did you have a test case?

The test case that reproduces the problem:
1) client1 opens "filename" (file that already has enough data ~~ 4096
bytes is ok)
2) client1 sets a read lock a file from pos=1 to pos=2
3) client2 opens "filename" - client1 gets oplock break to level II
and push lock from #2 to the server.
4) client1 writes 'a' to a file (from pos 0) - got status OK, but the
server reject the write (due to the client1 writes the whole page from
pos=0 to pos=4096 and conflicts with the read lock from pos=1 to
pos=2) - ERROR.
5) client2 reads 1 byte and got the old data (not 'a') because the
server returns it's version of the data

It is suitable for both CIFS and SMB2.

-- 
Best regards,
Pavel Shilovsky.

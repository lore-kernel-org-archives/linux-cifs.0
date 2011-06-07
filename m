From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: smb2 work status
Date: Tue, 7 Jun 2011 22:07:58 +0400
Message-ID: <BANLkTiktkRbNGX1bLWDV075HOMS9giFEsg@mail.gmail.com>
References: <BANLkTik5T2aY4V-Kp-AePZYUR+KgKCyNCA@mail.gmail.com>
	<BANLkTi=NEJ2smKXM_irraWnN6gWpzGbTvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=NEJ2smKXM_irraWnN6gWpzGbTvA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I found out the problem with the kernel hanging. The problem was in
query-info request - we need to set size of our buffer  in a request
but we had sizeof(FILE_ALL_INFO_SMB2) + sizeof(query_req) there. I
removed sizeof(query_req) and expand buffer to store information about
filename - (+ MAX_NAME*2).

So, I rebased my branch with this and other fixes and put it on top of
the current master. As the result, now I have mount/umount and stat
work correctly (according to my stress mount/stat/umount test).

pending cifs patches:
http://git.etersoft.ru/people/piastry/packages/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev

my patches:
http://git.etersoft.ru/people/piastry/packages/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev-experimental

As the next steps, I think we need to reconsider mid structure - now I
think that having one big structure for both protocols is the best way
to keep code cleaner. Also, I can start implementing inode/file
operations as well.

Comments?

-- 
Best regards,
Pavel Shilovsky.

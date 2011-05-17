From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: serverino by default?
Date: Tue, 17 May 2011 23:54:27 +0400
Message-ID: <BANLkTimDt8oOdzD9LpJAu4OyA6g8vOafrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In mount.cifs.8 page we have: "Client generates inode numbers (rather
than using the actual one from the server) by default", but if we look
at the code we can see that
we use server's numbers by default instead:

http://git.kernel.org/?p=linux/kernel/git/sfrench/cifs-2.6.git;a=blob;f=fs/cifs/connect.c;h=277262a8e82f282d4a32b0ddd4a244bc55e99472;hb=221d1d797202984cb874e3ed9f1388593d34ee22#l859

So, where is a error?

-- 
Best regards,
Pavel Shilovsky.

From: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: How the krb ticket is found?
Date: Sun, 24 Jun 2012 22:58:31 +0200
Message-ID: <CANXojczkVJ6j-Nowmb9bEc7M_wyc-D-=APs5JnD9G5SWQb50FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I'm would like to know how mount.cifs gets the right ticket?

In my situation the mount is done for a user. Simular like the setting of the
credentialsfile with credentials= option, but with kerberos how gets
mount.cifs the right
ticket, belonging to that user? Set the user= argument?

I'm not talking about multiuser mounts.

Is the cruid= the right option here??

Stef

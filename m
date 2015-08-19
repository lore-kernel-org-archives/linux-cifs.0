From: Yale Zhang <yzhang1985-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: strange bottleneck with SMB 2.0
Date: Wed, 19 Aug 2015 04:11:31 -0700
Message-ID: <CALQF7Zw5ET+uhgskMDMar31q1uo98nkSd9dusX4gQpS47-zKig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

SMB developers/users,

I'm experiencing a strange bottleneck when my files are mounted as SMB
2.0. When I launch  multiple processes in parallel for benchmarking,
only the 1st one starts, and the rest won't start until the 1st one
finishes:

---------------------------------------test
programs--------------------------------
#!/bin/sh
./a.out&
./a.out&
./a.out&
wait

a.out is just a C program like this:

int main()
{
  printf("greetings\n");
  while (true);
  return 0;
}

Apparently, this only affects SMB 2.0. I tried it with SMB 2.1, SMB
3.0, & SMB 3.02, and everything starts in parallel as expected.

I'm assuming SMB 3 and especially SMB 2.1 would share a common
implementation. How could 2.0 have the problem but not 3? It almost
seems the bottleneck is a feature instead of a bug?  8(

Can it still be fixed?

-Yale

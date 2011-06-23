From: Grazvydas Ignotas <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: DNS resolver cache does not expire
Date: Thu, 23 Jun 2011 17:19:25 +0300
Message-ID: <BANLkTim+Phg+cY6_KAhxhfSeDj1td_GALw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

one of our slave servers have changed it's address, and I can no
longer access it's shares that are forwarded to by the main server
using DFS redirection. The slave server resolves correctly when trying
to access it directly, but when trying to access through a mount on
the main server, cifsFYI shows dns_resolve_server_name_to_ip returns
the old address. I've verified slave server names match and windows
clients can access those DFS shares correctly. It has been several
days since server address change. I'm running 2.6.38.2 kernel on
Ubuntu 10.04.

Any way to clear that dns_resolver cache? I have no desire to reboot
the machine.

--=20
Gra=C5=BEvydas

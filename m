From: aye coder <acoder1999-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs mount with krb5: Required key not available
Date: Wed, 16 Sep 2015 12:10:06 -0400
Message-ID: <CAJXajaXCM1Ba-eG6RoUb6Da2Nes1zkjSSx2b1O7m_ZkW1WDtFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Good afternoon,

When attempting to cifs mount (with kerboros security mode) an Isilon
volume from RHEL 7 I get the following error.

-----------
    [user@clientbox ~]# mount -t cifs
//isilon.abc.example.com/share123/files /mnt/share123/files -o
username=acoder,password=XXXXXX,sec=krb5

    mount error(126): Required key not available
-----------

First, here's my /etc/krb5.conf file:

-----------
[libdefaults]
default_realm = EXAMPLE.COM
dns_lookup_realm = false
dns_lookup_kdc = false
ticket_lifetime = 24h
renew_lifetime = 7d
forwardable = true

[realms]
EXAMPLE.COM = {
kdc = eu.example.com
admin_server = eu.example.com
}

[domain_realm]
.example.com = EXAMPLE.COM
example.com = EXAMPLE.COM

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log
-----------

where eu.example.com is my organization's AD server.

Next, I show there are no current tickets stored on the client:

-----------
[user@mybox ~]# klist
klist: No credentials cache found (ticket cache FILE:/tmp/krb5cc_0)
-----------

Finally, I try to obtain a ticket using kinit:

-----------
[user@mybox ~]# kinit acoder
kinit: Cannot contact any KDC for realm 'EXAMPLE.COM' while getting
initial credentials
-----------

I'm not showing any additional information in /var/log/messages or
/var/log/krb5libs.log

1) Am I heading in the right direction?

2) If so, am I missing something from my krb5.conf file? What else do
I need to check?

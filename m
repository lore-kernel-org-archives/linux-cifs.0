From: Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
Subject: Re: Problem with Samba re-share of a CIFS mount
Date: Tue, 11 Feb 2014 18:05:49 +0100
Message-ID: <52FA586D.4080104@assyoma.it>
References: <52F9EDA5.1020004@assyoma.it> <20140211103302.6d74b90d@tlielax.poochiereds.net> <52FA46D5.8020904@assyoma.it> <CAH2r5mvXh2A_LOm5y7BpgKS6bQhNGjEDR8CYn=K2CnMv01HQeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvXh2A_LOm5y7BpgKS6bQhNGjEDR8CYn=K2CnMv01HQeQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,
these are my tests and results, complete with kernel and packages versions:

1) Stock CentOS 6.5 x86-64 system (kernel 2.6.32-431.1.2.0.1, cifs-utils
4.8.1-19, samba 3.6.9-167): no problem here, but this kernel does not
have CONFIG_CIFS_FSCACHE, so I can not use it for speeding up read
access;

2) CentOS 6.5 x86-64 with ElRepo updates (kernel 3.10.28-1): here
CONFIG_CIFS_FSCACHE is enabled, but I have the problem described above;

3) Debian 7 amd64 with latest updates (kernel 3.2.54-2, cifs-utils
2:5.5-1): CONFIG_CIFS_FSCACHE is enabled, problem happens;

4) Fedora 20 x86-64 (kernel 3.12.8-300, cifs-utils 6.3-1, samba
4.1.3-2): CONFIG_CIFS_FSCACHE is enabled and problem does _not_ happen,
however this is a client distro and I am not so comfortable to put it
into production.

In all cases, the share was published by a Win2008R2 server.

Continuing in my search, I found this:
https://lists.samba.org/archive/samba-technical/2013-August/094532.html

I can confirm that by forcing the use of CIFS ACL (using the cifsacl 
mount options) the problem disappear even on the problematic setups. An 
ls -al on the mount folder show 1 or more links. However, I am not sure 
if this is a good workaround.

Let me know you opinions.
Regards.

On 02/11/2014 05:59 PM, Steve French wrote:
> These are my results:
>>>>
>>>>1) Stock CentOS 6.5 x86-64 system (kernel 2.6.32-431.1.2.0.1, cifs-utils
>>>>4.8.1-19, samba 3.6.9-167): no problem here, but this kernel does not
>>>>have CONFIG_CIFS_FSCACHE, so I can not use it for speeding up read
>>>>access;
>>>>
>>>>2) CentOS 6.5 x86-64 with ElRepo updates (kernel 3.10.28-1): here
>>>>CONFIG_CIFS_FSCACHE is enabled, but I have the problem described above;
>>>>
>>>>3) Debian 7 amd64 with latest updates (kernel 3.2.54-2, cifs-utils
>>>>2:5.5-1): CONFIG_CIFS_FSCACHE is enabled, problem happens;
>>>>
>>>>4) Fedora 20 x86-64 (kernel 3.12.8-300, cifs-utils 6.3-1, samba
>>>>4.1.3-2): CONFIG_CIFS_FSCACHE is enabled and problem does_not_  happen,
>>>>however this is a client distro and I am not so comfortable to put it
>>>>into production.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org - info-N44kj/XGErOonA0d6jMUrA@public.gmane.org
GPG public key ID: FF5F32A8

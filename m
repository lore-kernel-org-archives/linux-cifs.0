From: Dame Dimitrov <ddimitro-vkGj3nKBv85YqTQye2laTg@public.gmane.org>
Subject: Backporting the CIFS module
Date: Wed, 31 Jul 2013 14:13:46 +0000 (UTC)
Message-ID: <loom.20130731T161003-507@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

We're planning to replace some NFS mounts with CIFS mounts,  with the help
multiuser option of CIFS.
But unfortunately we have some CentOS 5 machines, and the cifs.ko kernel
module (v. 1.60) does not support the multiuser option,
Can anyone give a hint how can I backport for example the cifs module from
CentOS6 (v. 1.68) to CentOS5, and if it's at all doable?

Thanks and cheers,
Dame.

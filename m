From: Ketil Froyn <ketil-wcohQK4BhvFBDLzU/O5InQ@public.gmane.org>
Subject: Linux CIFS and Nexenta compatibility issue
Date: Fri, 7 Jun 2013 13:15:53 +0200
Message-ID: <CAPcdcpJ4CjPDVB0SLNkouugubuif_z0JiV24QwwrQwPMFoTefQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I have a Nexenta system (based on OpenSolaris/IllumOS) running ZFS
shared with CIFS. After upgrading to Ubuntu 13.04, I'm unable to mount
the Nexenta CIFS shares. I've posted an Ubuntu bug report here with
details (though I'm not sure cifs-utils was the right place to report
this), including cifsFYI enabled trace of the mount operation:

https://bugs.launchpad.net/ubuntu/+source/cifs-utils/+bug/1185025

In the test results shown, I had specified my username and password to
mount. I have since discovered that when specifying my
username/password directly to mount, I am able to mount the shares
with the sec=ntlm or sec=ntlmv2 options. However, I've used
Likewise-Open to sign my desktop into the AD domain, so that any AD
user ID can log on to Ubuntu, and then get CIFS shares automounted
with the user's credentials. I guess mount uses sec=krb5 to mount
these shares.  That still fails with the same log output. This works
fine on all the shares except Nexenta shares, and with Ubuntu 12.10
the Nexenta shares worked fine.

So there appears to be some sort of CIFS compatibility issue between
Nexenta OS 3.1.3.5 and Ubuntu 13.04. In short, all other OS-es
(Windows, Mac, other versions of Ubuntu) work with the Nexenta OS
3.1.3.5 CIFS server and all other CIFS servers in the domain, and
Ubuntu 13.04 works with all other CIFS servers in the domain, but not
the Nexenta 3.1.3.5 server. So something in the linux CIFS codebase
between Ubuntu 12.10 and 13.04 appears to have triggered this error.

Is there anything else I can do to find out exactly what is happening,
and whether this is linux CIFS' or Nexenta OS's fault, or a
combination?

Ubuntu 13.04 uses cifs-utils 5.5, presumably with some Ubuntu patches,
and linux kernel 3.8.0, presumably also with Ubuntu patches.

Regards, Ketil

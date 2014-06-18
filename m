From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: cifs SRV record
Date: Wed, 18 Jun 2014 16:19:27 +0200
Message-ID: <1403101167.9166.6.camel@hh16.hh3.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi
Is it possible to have cifs SRV rrs like ldap and kerberos where clients
can look for the service themselves? We'd like to be able to offer
shares on more than one server without the cluster stuff.

ATM we have e.g.
mount -t cifs //server/share -owhatever

Our question is, would having cifs SRV be a  way around having to
specify a specific server?
Cheers,
Steve

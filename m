From: "Ross, Matt" <m.g.ross-OfppCuUFkUX10XsdtD+oqA@public.gmane.org>
Subject: RE: Using PAM module without Kerberos
Date: Tue, 4 Mar 2014 15:19:46 +0000
Message-ID: <BC8B39086BF9F141A4EB3AAF7D7AAF2E026EA52961@UH-MAILSTOR.herts.ac.uk>
References: <BC8B39086BF9F141A4EB3AAF7D7AAF2E026E5E69D5@UH-MAILSTOR.herts.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
To: "Ross, Matt" <m.g.ross-OfppCuUFkUX10XsdtD+oqA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BC8B39086BF9F141A4EB3AAF7D7AAF2E026E5E69D5-aYJdjl9JfU56Lw2yR1Z5fGf8YopGCnRN@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I have managed to solve this myself by moving up the 'pam_cifscreds' session entry in PAM's 'common-session' directly after the 'pam_keyinit' line:

session optional        pam_keyinit.so force revoke debug
session optional        pam_cifscreds.so host=cifsserver.ourdomain debug
session sufficient      pam_unix.so
session required        pam_ldap.so use_first_pass

I should have read Orion's original description more closely.

Thanks for your continued efforts that make my life easier.

Matt

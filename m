From: Jorell <JorellF-97jfqw80gc7k1uMJSBkQmQ@public.gmane.org>
Subject: Re: linux-cifs 5.4 problems...
Date: Tue, 22 May 2012 17:33:33 -0700
Message-ID: <jphb90$65r$1@dough.gmane.org>
References: <jpgne8$fod$1@dough.gmane.org> <4FBC01A5.9000605@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FBC01A5.9000605-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Aside from wbclient.pc missing configure still completes and there is a 
wbclient.pc with samba3. I include that path in PKG_CONFIG_PATH and the 
two warnings during configure disappear. Now I just don't understand 
these errors durning make:
mount.cifs.c:866: error: "bkupuid" may be used uninitialized in this 
function
mount.cifs.c:867: error: "bkupgid" may be used uninitialized in this 
function

Or is the wbclient.pc with samba3 that different?
Is there a wbclient in a different debian repo? which one?

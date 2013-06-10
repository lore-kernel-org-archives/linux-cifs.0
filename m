From: Ted Miller <tmiller-fFyIe9EmHoY@public.gmane.org>
Subject: xattr "trusted" namespace
Date: Mon, 10 Jun 2013 18:50:51 -0400
Message-ID: <51B6584B.8010906@hcjb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
To: Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(If this is the wrong place to ask this question, please feel free to point 
me in a different direction.)

I am working on a system that needs to be able to write to the xattr 
namespace "trusted", as in trusted.xyz.  I only need this support from the 
Linux client, as the target file is being served by a Windows server.  I have 
tried this using Centos (same package versions as RHEL) 6.4, and the writes 
all fail with the default client.  I am hoping that this has been addressed 
in a newer version of the CIFS client.

Is the "trusted" namespace accessible in the current Linux CIFS client?  If 
so, what version of which file(s) do I need to look for?

Thank you,
Ted Miller
Elkhart, IN, USA

From: Andrew Martin <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Configuring CIFS mount with cifsacl - STATUS_NONE_MAPPED
Date: Wed, 10 Dec 2014 09:16:36 -0600 (CST)
Message-ID: <741749879.14098.1418224596026.JavaMail.zimbra@xes-inc.com>
References: <982926402.71713.1416844711273.JavaMail.zimbra@xes-inc.com> <CADT32eKWbwvuvr4mJObenG4vquuhkGX=zcjagEYnC8DzoGfZpw@mail.gmail.com> <1207991829.78949.1418059795674.JavaMail.zimbra@xes-inc.com> <CADT32e+Sx-qv1yKZy-WGjwFwnok0vS4hR=PX+1Ke1x9RjFH8Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+Sx-qv1yKZy-WGjwFwnok0vS4hR=PX+1Ke1x9RjFH8Yw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

----- Original Message -----
> From: "Shirish Pargaonkar" <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> To: "Andrew Martin" <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
> Cc: "linux-cifs" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Sent: Wednesday, December 10, 2014 12:04:30 AM
> Subject: Re: Configuring CIFS mount with cifsacl - STATUS_NONE_MAPPED
> 
> Not sure what to make out of the error STAUS_NONE_MAPPED! That error
> is not returned by the Solaris cifs server in response to all of the
> NT QUERY SECURITY DESCRIPTOR requests from cifs client but only for some
> (e.g. the error is returned for security descriptor query for \CMM but
> not for \ssd)
> 

Both \CMM and \ssd have the same set of ACLs applied to them:
A:d:OWNER@:rwaDdxtTnNcCoy
A:fi:OWNER@:rwaDdtTnNcCoy
A:dg:Domain Users-sLNbH/y3q2k@public.gmane.org:rwaDdxtTnNcCoy
A:fig:Domain Users-sLNbH/y3q2k@public.gmane.org:rwaDdtTnNcCoy
A:dg:GROUP@:rxtncy
A:fig:GROUP@:rtncy
D:d:EVERYONE@:rwaDxtTcCy

I noticed that the sticky bit was set on \ssd but not on \CMM:

\CMM:
drwxrwx---

\ssd:
drwxrwx--T

I tried setting it on \CMM and then running the capture again, but am 
still getting STATUS_NONE_MAPPED. What else can I try to debug this?

Thanks,

Andrew

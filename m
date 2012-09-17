From: Steve Finley <Steve.Finley-SOxAPD1SrF7V1CgomF1qdQ@public.gmane.org>
Subject: many-to-one nested CIFS serving
Date: Mon, 17 Sep 2012 15:45:54 -0600
Message-ID: <50579A12.7070805@colostate.edu>
Reply-To: Steve.Finley-SOxAPD1SrF7V1CgomF1qdQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

To Whom:

I am exploiting a feature of the CIFS server that works for the client under
Windows 8 (not sure about others), but does not work for the linux client
under RedHat/CentOS5/6.

I am mounting multiple Thecus NAS devices via CIFS, making
symbolic links to files on those NAS devices, where I reorganize the
directory structure, and then turn around and serve the top level
of that directory via CIFS.

On a Windows machine I only have to mount that top level directory, and
the symbolic links automatically resolve themselves without having to also
mount the NAS device(s).  THIS IS VERY POWERFUL.  On a linux
machine however, the symbolic links can only be resolved if I have the
NAS devices mounted, and the mount points have to be named as shown
in the link.  It seems that the protocol necessary for this to work under
Windows has not been added to the linux version of the client.

When I surf the web for others exploiting this feature, I find nothing.

Thanks

Steve Finley
Research Associate
CIRA - Colorado State University

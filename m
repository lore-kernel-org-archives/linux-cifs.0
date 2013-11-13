From: Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>
Subject: multiuser mount without initial mount credentials
Date: Wed, 13 Nov 2013 16:14:44 -0700
Message-ID: <528407E4.3030205@cora.nwra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Is there any possibility of removing the requirement to have an initial set of 
credentials when mounting a cifs filesystem as multiuser?  I'd like to have an 
automount driven multiuser configuration without the need to have a separate 
set of credentials just for mounting.  Could we imaging some way for the 
automount process to access a keyring stored credential for use in mounting?

-- 
Orion Poplawski
Technical Manager                     303-415-9701 x222
NWRA, Boulder/CoRA Office             FAX: 303-415-9702
3380 Mitchell Lane                       orion-CfuHcwXVrUc@public.gmane.org
Boulder, CO 80301                   http://www.nwra.com

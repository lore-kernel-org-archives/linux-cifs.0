From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 0/3] cifs: Better dependencies
Date: Fri, 22 Jan 2016 10:16:54 +0100
Message-ID: <20160122101654.20fa96e3@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

This is my attempt to fix and improve the dependencies of cifs.

[PATCH 1/3] cifs: Simplify SMB2 and SMB311 dependencies
[PATCH 2/3] cifs: Only select the required crypto modules
[PATCH 3/3] cifs: Add soft dependencies

-- 
Jean Delvare
SUSE L3 Support

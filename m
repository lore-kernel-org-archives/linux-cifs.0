From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC][PATCH 0/3] CIFS: Use OID registry and ASN.1 header
Date: Mon, 22 Oct 2012 15:23:19 +0100
Message-ID: <20121022142318.6989.5077.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Hi Steve,

Here are some patches that might be of interest for CIFS:

 (1) The first patch uses the OID registry I created for module signing's use
     of X.509 certs and potentially PKCS#7.  The lookup function finds the OIDs
     from its table (using a hash value to speed up the binary search) and maps
     known OIDs onto values in an enum.

 (2) The second and third patches make CIFS use the linux/asn1.h file for
     common ASN.1 constant definitions.  Note that ASN1_OJI is now ASN1_OID
     since 'OBJECT IDENTIFIER' is almost always abbreviated to 'OID'.

David
---
David Howells (3):
      CIFS: Use linux/asn1.h
      ASN.1: Define indefinite length marker constant
      CIFS: Use OID registry facility


 fs/cifs/Kconfig              |    1 
 fs/cifs/asn1.c               |  230 +++++++++---------------------------------
 include/linux/oid_registry.h |    6 +
 3 files changed, 59 insertions(+), 178 deletions(-)

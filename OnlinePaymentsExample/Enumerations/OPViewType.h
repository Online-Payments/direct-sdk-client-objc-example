//
// Do not remove or alter the notices in this preamble.
// This software code is created for Online Payments on 21/07/2020
// Copyright © 2020 Global Collect Services. All rights reserved.
// 

#ifndef OPViewType_h
#define OPViewType_h

typedef enum {
    // Switches
    OPSwitchType,
    
    // PickerViews
    OPPickerViewType,
    
    // TextFields
    OPTextFieldType,
    OPIntegerTextFieldType,
    OPFractionalTextFieldType,
    
    // Labels
    OPLabelType,

    // TableViewCells
    OPPaymentProductTableViewCellType,
    OPTextFieldTableViewCellType,
    OPCurrencyTableViewCellType,
    OPErrorMessageTableViewCellType,
    OPSwitchTableViewCellType,
    OPPickerViewTableViewCellType,
    OPButtonTableViewCellType,
    OPLabelTableViewCellType,
    OPTooltipTableViewCellType,
    OPCoBrandsSelectionTableViewCellType,
    OPCoBrandsExplanationTableViewCellType,

    // TableHeaderView
    OPSummaryTableHeaderViewType,
    
    //TableFooterView
    OPButtonsTableFooterViewType
    
} OPViewType;

#endif /* OPViewType_h */
